require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it '作品を投稿するを押すと、新規投稿画面に遷移する' do
        new_post_link = find_all('a')[2].text
        click_link new_post_link
        is_expected.to eq '/posts/new'
      end
      it 'マイページを押すと、ログインユーザの詳細画面に遷移する' do
        mypage_link = find_all('a')[3].text
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '検索を押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[4].text
        click_link posts_link
        is_expected.to eq '/posts/search_index'
      end
      it 'ユーザー一覧を押すと、ユーザー一覧画面に遷移する' do
        users_link = find_all('a')[5].text
        click_link users_link
        is_expected.to eq '/users'
      end
    end
  end
  
  describe '検索画面のテスト' do
    before do
      visit search_index_posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/search_index'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      # 下記エラーを修正する
      #it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        #expect(page).to have_link post.title, href: post_path(post)
        #expect(page).to have_link other_post.title, href: post_path(other_post)
      #end
      #it '自分の投稿と他人の投稿のタグが表示される' do
        #expect(page).to have_content tag.tag_name
        #expect(page).to have_content other_tag.tag_name
      #end
    end
  end
end