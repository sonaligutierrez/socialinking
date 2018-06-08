require "test_helper"

class ExtractDataInBatchJobTest < ActiveJob::TestCase
  def setup
    @account = Account.new(name: "test name", url: "https://www.prosumia.la/")
    @post_creator = PostCreator.new(fan_page: "Cambiemos", url: "https://www.facebook.com/cambiemos/", avatar: "https://scontent.fscl6-1.fna.fbcdn.net/v/t1.0-1/p200x200/33468449_1111474448991887_5106211791294169088_n.jpg?_nc_cat=0&oh=84060e2f2a85fadcf4d24ff2d08872e9&oe=5B872929", created_at: "2018-05-28 18:12:12", updated_at: "2018-06-06 20:22:39", fb_user: "luiseloyhernandez@gmail.com", fb_pass: "xyzw123456")
    @post_creator.account = @account
    @post_creator.save!
    @cat = Category.new(name: "Uncategorized").save!
    @fb_post = Post.new(date: "2018-05-28 18:12:13.233476", created_at: "2018-05-28 18:12:13.233476", post_date: "2018-05-28 18:12:13.233476", url: "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507")
    @fb_post.post_creator = @post_creator
    @fb_post.save!
  end

  test "scraping execution for a post" do
    VCR.use_cassette("fb_scraping") do
      count = ExtractDataInBatchJob.perform_now @fb_post # , "luiseloyhernandez@gmail.com", "xyzw123456"
      puts "Procesados: #{count} comments"
    end
  end
end
