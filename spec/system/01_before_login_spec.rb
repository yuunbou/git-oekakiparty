require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
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
end