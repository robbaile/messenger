require 'sinatra/base'
require './lib/user'

class Messenger < Sinatra::Base

    enable :sessions
    
    get '/' do 
        if session[:login] == true 
            redirect('/home')
        else
            redirect('/login')
        end
    end

    get '/login' do 
        erb(:login)
    end

    post '/login' do 
        result = User.find(params['email'], params['password'])
        if result.length == 1
            session[:user] = result.first
            redirect('/home')
        else 
            redirect('/oops')
        end    
    end

    get '/signup' do
        erb(:signup)
    end

    post '/signup' do 
        User.create(params['email'], params['password'])
        redirect('/login')
    end

    get ('/home') do
        if !session[:user]
            redirect('/login')
        else
            @user = session[:user]
            @posts = User.get_posts(@user.id)
            erb(:home)
        end
    end

    post ('/posts') do 
        redirect('/login') if !session[:user]
            
        @user = session[:user]
        message = params[:message]
        User.create_post(@user.id, message)
        redirect('/home')
    end

    get ('/delete/:id') do 
        redirect('/login') if !session[:user]

        User.delete_post(params[:id])
        redirect('/home')
    end

    get ('/users') do
        redirect('/login') if !session[:user]

        @users = User.get_users(session[:user].id)
        erb(:users)
    end
    
    get ('/oops') do 
        "Oops"
    end

    get ('/logout') do 
        session.clear
        redirect('/login')
    end
end