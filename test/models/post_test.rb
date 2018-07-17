require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "get page info" do
    post = posts(:page_info)
    VCR.use_cassette("fb_scraping_page_info", record: :new_episodes) do
      post.scraping
      assert_equal "Frente Renovador", post.title
      assert_match "UN FRENO A LOS INGRESOS", post.description
      assert_equal "https://scontent.fscl6-1.fna.fbcdn.net/v/t1.0-9/fr/cp0/e15/q65/34087000_829533060590810_3474770405233786880_o.jpg?_nc_cat=0&oh=dec6ebda28efe30fad73da43f715d4d1&oe=5BC90A2F", post.image
    end
  end

  test "scraping comments with paging" do
    post = posts(:three)
    VCR.use_cassette("fb_scraping", record: :new_episodes) do
      assert_difference "PostComment.count", 117  do
        post.scraping
      end
    end
  end

  test "scraping comments one page" do
    post = posts(:four)
    VCR.use_cassette("fb_scraping_one_page", record: :new_episodes) do
      assert_difference "PostComment.count", 4  do
        post.scraping
      end
    end
  end

  test "scraping log " do
    post = posts(:three)
    VCR.use_cassette("fb_scraping", record: :new_episodes) do
      assert_difference "ScrapingLog.count"  do
        post.scraping
      end
    end
  end
end
