require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    
    context 'ログイン前のヘッダーの表示内容確認' do
      it 'ヘッダーにお絵描きpartyが表示されているか' do
        root_link = find_all('a')[1].text
        expect(root_link).to match(/お絵描きparty/)
      end
      it 'ヘッダーのお絵描きpartyがリンクになっているか' do
        expect(page).to have_link "", href: root_path
      end
      it 'Aboutリンクが表示される: 青緑のボタンの表示が「About」である' do
        about_link = find_all('a')[2].text
        expect(about_link).to match(/About/)
      end
      it 'ヘッダーにAboutページへのリンクが表示されている' do
        expect(page).to have_link "", href: about_path
      end
      it 'ヘッダーに新規登録が表示される: 青色のボタンの表示が「新規登録」である' do
        sign_up_link = find_all('a')[3].text
        expect(sign_up_link).to match(/新規登録/)
      end
      it 'ヘッダーに新規登録ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_registration_path
      end
      it 'ヘッダーにログインリンクが表示される: 青緑のボタンの表示が「ログイン」である' do
        log_in_link = find_all('a')[4].text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'ヘッダーにログインページへのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_session_path
      end
      it 'ヘッダーにゲストログインリンクが表示される: 紺色のボタンの表示が「ゲストログイン」である' do
        guest_log_in_link = find_all('a')[5].text
        expect(guest_log_in_link).to match(/ゲストログイン/)
      end
      it 'ヘッダーにゲストログインボタンが表示されているか' do
        expect(page).to have_link "", href: users_guest_sign_in_path
      end
    end
    
    context '表示内容の確認' do
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
      it '新規登録リンクが表示される: 青色のボタンの表示が「新規登録」である' do
        # []の中にはHTMLの上から数えてn番目の数を入れる
        sign_up_link = find_all('a')[6].text
        expect(sign_up_link).to match(/新規登録/)
      end
      it 'トップ画面(root_path)に新規登録ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_registration_path
      end
      it 'ログインリンクが表示される: 青緑のボタンの表示が「ログイン」である' do
        log_in_link = find_all('a')[7].text
        expect(log_in_link).to match(/ログイン/)
      end
      it 'トップ画面(root_path)にログインページへのリンクが表示されているか' do
        expect(page).to have_link "", href: new_user_session_path
      end
      it 'ゲストログインリンクが表示される: 紺色のボタンの表示が「ゲストログイン」である' do
        guest_log_in_link = find_all('a')[8].text
        expect(guest_log_in_link).to match(/ゲストログイン/)
      end
      it 'トップ画面(root_path)にゲストログインボタンが表示されているか' do
        expect(page).to have_link "", href: users_guest_sign_in_path
      end
    end
  end
  
  describe 'アバウト画面のテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq ('/about')
      end
    end
  end
  
  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end
  
    context 'リンクの内容を確認' do
      subject { current_path }
      
    it 'お絵描きpartyを押すと、トップ画面に遷移する' do
      #byebug
        root_link = find('.navbar .title').text
        root_link = root_link.delete(' ').gsub(/\n/, '')
        #root_link.gsub!(/\n/, '')
        click_link root_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].text
        click_link about_link
        is_expected.to eq '/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].text
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].text
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
      it 'ゲストログインを押すと、トップ画面に遷移する' do
        guestlogin_link = find_all('a')[5].text
        click_link guestlogin_link, match: :first
        is_expected.to eq '/'
      end
    end
  end
  
  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'ニックネームフォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '登録するボタンが表示される' do
        expect(page).to have_button '登録する'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '登録する' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '登録する'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end
  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'メールアドレスフォームが表示されている' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it 'ニックネームフォームは表示されない' do
        expect(page).not_to have_field 'user[nickname]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、トップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end