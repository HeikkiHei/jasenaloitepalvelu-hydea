require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

	context "User not logged in" do

		describe "GET #index" do
		  it "It doesn't return user page" do
        get :index
				expect(response).to redirect_to ideas_path
      end
		end

		describe "GET #show" do
			it "It doesn't return user page" do
			  user = FactoryGirl.create(:user)
			  get :show, params: { id: user }
			  expect(response).to redirect_to ideas_path
			end
		end


		describe "GET #new" do
			it "doesn't get new, if not admin" do
        expect{get :new}.to raise_error(ActionController::UrlGenerationError)
			end
		end

		describe "GET #edit" do
			it "doesn't edit, if not admin" do
				user = FactoryGirl.create(:user)
				get :edit, params: { id: user }
				expect(response).to redirect_to ideas_path
			end
		end

		describe "PUT #update" do
			it "doesn't update name, if not admin" do
				@user = FactoryGirl.create(:user)
		        put :update, params: { id: @user, user: FactoryGirl.attributes_for(:user, name: "vaihdettu") }
		        @user.reload
			    expect(@user.name).to eq("Testi Tauno")
			end
		end
		
	end


	context "Admin user logged in" do
		before :each do
			current_user = FactoryGirl.create(:user_admin)
		    session[:user_id] = current_user.id
		end

    describe "GET #index" do
			it "shows all users" do
        get :index
			  expect(response).to render_template :index
		  end
		end

		describe "GET #show" do
			it "assigns the requested user to @user" do
		    user = FactoryGirl.create(:user)
			get :show, params: { id: user }
			expect(assigns(:user)).to eq(user)
			expect(response).to render_template :show
			end

		end

		describe "PUT #update" do
			it "update name" do
				@user = FactoryGirl.create(:user)
		        put :update, params: { id: @user, user: FactoryGirl.attributes_for(:user, name: "vaihdettu") }
		        @user.reload
		        expect(@user.name).to eq("vaihdettu")
			end
			it "updates title" do
				@user = FactoryGirl.create(:user)
				expect(@user.title).not_to eq("Puheenjohtaja")
				put :update, params: {id: @user, user: FactoryGirl.attributes_for(:user, title: "Puheenjohtaja")}
				@user.reload
				expect(@user.title).to eq("Puheenjohtaja")
			end
		end

    describe 'edits user' do
      it 'removing moderator' do
        @user_moderator = FactoryGirl.create(:user_moderator)
        expect(@user_moderator.moderator).to be true
        put :update, params: { id: @user_moderator, user: FactoryGirl.attributes_for(:user, moderator: :false)}
        @user_moderator.reload
        expect(@user_moderator.moderator).to be false
      end

			it 'adding moderator moderator' do
        @user = FactoryGirl.create(:user_student)
        expect(@user.moderator).to be false
        put :update, params: { id: @user, user: FactoryGirl.attributes_for(:user, moderator: :true)}
        @user.reload
        expect(@user.moderator).to be true
      end
    end
  end


	context "Basic user logged in" do
		before :each do
			current_user = FactoryGirl.create(:user_student)
		    session[:user_id] = current_user.id
		end

		describe "GET #index" do
		 	it "Doesn't let them access user list" do
		  	get :index
		   	expect(response).to redirect_to ideas_path
      end
		end


		describe "GET #show" do
			it "It returns user page" do
				user = FactoryGirl.create(:user)
				get :show, params: { id: user }
				expect(assigns(:user)).to eq(user)
				expect(response).to render_template :show
			end
		end


		describe "GET #new" do
			it "doesn't get new, if not admin" do
        expect{get :new}.to raise_error(ActionController::UrlGenerationError)
			end
		end

		describe "GET #edit" do
			it "doesn't edit, if not admin" do
				user = FactoryGirl.create(:user)
				get :edit, params: { id: user }
				expect(response).to redirect_to ideas_path
			end
		end

		describe "PUT #update" do
			it "doesn't update name" do
				@user = FactoryGirl.create(:user)
		        put :update, params: {id: @user, user: FactoryGirl.attributes_for(:user, name: "vaihdettu")}
		        @user.reload
			expect(@user.name).to eq("Testi Tauno")
			end
			it "doesn't update title" do
				@user = FactoryGirl.create(:user)
				expect(@user.title).not_to eq("Puheenjohtaja")
				put :update, params: {id: @user, user: FactoryGirl.attributes_for(:user, title: "Puheenjohtaja")}
				@user.reload
				expect(@user.title).not_to eq("Puheenjohtaja")
			end
		end
		
	end

	context "banned moderator logged in" do
		before :each do
      
			current_user = FactoryGirl.create(:user_banned, moderator: true)
		    session[:user_id] = current_user.id
		end

		describe "GET #index" do
		 	it "Doesn't let them access user list" do
		  	get :index
		   	expect(response).to redirect_to ideas_path
      end
		end


		describe "GET #show" do
			it "Doesn't let them access user view" do
				user = FactoryGirl.create(:user)
				get :show, params: { id: user }
				expect(assigns(:user)).to eq(user)
				expect(response).not_to render_template :show
			end
		end


		describe "GET #new" do
			it "doesn't get new, if not admin" do
        expect{get :new}.to raise_error(ActionController::UrlGenerationError)
			end
		end

		describe "GET #edit" do
			it "doesn't edit, if not admin" do
				user = FactoryGirl.create(:user)
				get :edit, params: { id: user }
				expect(response).to redirect_to ideas_path
			end
		end

		describe "PUT #update" do
			it "doesn't update name" do
				@user = FactoryGirl.create(:user)
		        put :update, params: {id: @user, user: FactoryGirl.attributes_for(:user, name: "vaihdettu")}
		        @user.reload
			expect(@user.name).to eq("Testi Tauno")
			end
			it "doesn't update title" do
				@user = FactoryGirl.create(:user)
				expect(@user.title).not_to eq("Puheenjohtaja")
				put :update, params: {id: @user, user: FactoryGirl.attributes_for(:user, title: "Puheenjohtaja")}
				@user.reload
				expect(@user.title).not_to eq("Puheenjohtaja")
			end
		end
		
	end

	context 'User #show is viewed' do
		before :each do
			user = FactoryGirl.create(:user)
			session[:user_id] = user.id
			idea1 = FactoryGirl.create(:idea, topic: 'topic1')
			idea1.histories.first.user = user
			user.histories << idea1.histories.first
			idea2 = FactoryGirl.create(:idea, topic: 'topic2')
			idea2.histories.first.user = user
			user.histories << idea2.histories.first
			idea3 = FactoryGirl.create(:idea, topic: 'topic3')
			idea3.histories.first.user = user
			user.histories << idea3.histories.first
			moderator = FactoryGirl.create(:user_moderator)
			session[:user_id] = moderator.id
			idea2.histories << FactoryGirl.create(:history, basket: 'Approved')
			idea3.histories << FactoryGirl.create(:history, basket: 'Rejected')
			session[:user_id] = user.id
			get :show, params: { id: user }

		end

		render_views

		describe 'by the user' do
			it 'and all ideas are shown' do
				expect(response).to render_template :show
				expect(response.body).to have_content('topic1')
				expect(response.body).to have_content('topic2')
				expect(response.body).to have_content('topic3')
			end
		end

		describe 'by other user' do
			it 'and New and Rejected ideas are not shown' do
				newUser = FactoryGirl.create(:user, persistent_id: 123456789, name: "esa")
				session[:user_id] = newUser.id
				get :show, params: { id: 1 }
				expect(response).to render_template :show
				expect(response.body).to have_content('topic2')
				expect(response.body).not_to have_content('topic1')
				expect(response.body).not_to have_content('topic3')
			end
		end

		describe 'by moderator' do
			it 'and all ideas are shown' do
				moderator = FactoryGirl.create(:user_moderator, persistent_id: 123456789)
				session[:user_id] = moderator.id
				get :show, params: { id: 1 }
				expect(response).to render_template :show
				expect(response.body).to have_content('topic1')
				expect(response.body).to have_content('topic2')
				expect(response.body).to have_content('topic3')
			end
		end

		describe 'by admin' do
			it 'and New and Rejected ideas are not shown' do
				admin = FactoryGirl.create(:user_admin, persistent_id: 123456789)
				session[:user_id] = admin.id
				get :show, params: { id: 1 }
				expect(response).to render_template :show
				expect(response.body).to have_content('topic2')
				expect(response.body).not_to have_content('topic1')
				expect(response.body).not_to have_content('topic3')
			end
		end
	end
end
