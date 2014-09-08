require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"

require_relative 'models/contact'

before do
  contact_attributes = [
    { first_name: 'Eric', last_name: 'Kelly', phone_number: '1234567890' },
    { first_name: 'Adam', last_name: 'Sheehan', phone_number: '1234567890' },
    { first_name: 'Dan', last_name: 'Pickett', phone_number: '1234567890' },
    { first_name: 'Evan', last_name: 'Charles', phone_number: '1234567890' },
    { first_name: 'Faizaan', last_name: 'Shamsi', phone_number: '1234567890' },
    { first_name: 'Helen', last_name: 'Hood', phone_number: '1234567890' },
    { first_name: 'Corinne', last_name: 'Babel', phone_number: '1234567890' }
  ]

  contact_attributes.each do |attributes|
    contact = Contact.new(attributes)
    contact.save
  end
end


def validation_results(first_name, last_name)
  error_messages = []

  if first_name.length == 0
    error_messages << "The first name field was left blank.  Please fill in the first name."
  end

  if last_name.length == 0
    error_messages << "The last name field was left blank.  Please fill in the last name field."
  end

  error_messages
end

#####################
#####################
#####################
#####################

get '/' do
  page_num  = params[:page] ? params[:page].to_i : 1
  @contacts = Contact.all.limit(5).offset((page_num - 1) * 5)
  erb :index
end

get '/search' do
  @first_name = ''
  @last_name  = ''
  @error_messages = []

  erb :search
end

post '/search' do
  first_name  = params["first_name"]
  last_name   = params["last_name"]
  error_messages = []
  error_messages = validation_results(first_name, last_name)

  if error_messages.length == 0
    @contacts = Contact.where(first_name: first_name, last_name: last_name)

    erb :index
  else
    @first_name   = first_name
    @last_name    = last_name
    @error_messages = error_messages

    erb :search
  end
end

get '/submit' do
  @first_name = ''
  @last_name  = ''
  @error_messages = []

  erb :submit
end

post '/submit' do
  first_name    = params["first_name"]
  last_name     = params["last_name"]
  phone_number  = params["phone_number"]
  error_messages = []
  error_messages = validation_results(first_name, last_name)

  if error_messages.length == 0
    @contacts = [Contact.find_or_create_by(first_name: first_name, last_name: last_name, phone_number: phone_number)]
    erb :index
  else
    @first_name   = first_name
    @last_name    = last_name
    @error_messages = error_messages

    erb :submit
  end
end


