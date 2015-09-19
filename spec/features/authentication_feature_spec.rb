require 'spec_helper'

describe 'user_authentication'  do   
  let(:user) { build(:user) }
  let!(:account) { create(:account, owner: user) }

  it 'allows signin with valid credentials' do
    sign_user_in(user, subdomain: account.subdomain)
    expect(page).to have_content('Signed in successfully.')
  end

  it 'does not allow signin with invalid credentials' do
    sign_user_in(user, subdomain: account.subdomain, password: 'wrong pw')

    expect(page).to have_content('Invalid email or password')
  end

  it 'does not allow user to sign in unless on subdomain' do
    expect{ visit new_user_session_path }.to raise_error ActionController::RoutingError
  end

  it 'allows user to sign out' do
    sign_user_in(user, subdomain: account.subdomain)

 
    click_link 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end

def sign_user_in(user, opts={})
  visit new_user_session_url(subdomain: opts[:subdomain])
  fill_in 'Email', with: user.email
  fill_in 'Password', with: (opts[:password] || user.password)
  click_button 'Sign in'
end
