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
            erb(:home)
        end
    end

    get ('/oops') do 
        "Oops"
    end
end