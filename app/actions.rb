helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

get '/signup' do    #if a user navigates to the path "signup",
    @user =User.new #setup empty @user objext
    erb(:signup)    #render "app/views/signup.erb"
end

post '/signup' do

# grab user input from values from params
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]

    # instantiate a User
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

    if @user.save
        redirect to ('/login')
    else
        erb(:signup)
    end
end

get '/login' do #when a GET request comes to /login
    erb(:login) #render app/views/login.erb
end

post '/login' do #when we submit a form with an action of /login
    params.to_s  #just display the params for now to make sure it's working
    username = params[:username]
    password = params[:password]

    #1. find user by username
    user = User.find_by(username: username)
    #2. if that user exists + if the passwords match
    if user && user.password == password
        session[:user_id] = user.id
        redirect to('/')
    else
        @error_message = "Login failed."
        erb(:login)
    end
end

get '/logout' do
    session[:user_id] = nil
    redirect to('/')
end