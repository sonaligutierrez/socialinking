require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "get page info" do
    post = posts(:page_info)
    VCR.use_cassette("fb_scraping_page_info_v2") do
      post.scraping_comments
      assert_equal "Frente Renovador", post.title
      assert_match "UN FRENO A LOS INGRESOS", post.description
      assert_equal "https://scontent-scl1-1.xx.fbcdn.net/v/t1.0-9/fr/cp0/e15/q65/34087000_829533060590810_3474770405233786880_o.jpg?_nc_cat=102&_nc_ht=scontent-scl1-1.xx&oh=af34cb1c7d94acd5a5aca2498dc0c45b&oe=5C673E2F", post.image
    end
  end

  test "scraping comments with paging" do
    post = posts(:three)
    VCR.use_cassette("fb_scraping") do
      assert_difference "PostComment.count", 118  do
        post.scraping_comments
      end
    end
  end

  test "scraping comments one page" do
    post = posts(:four)
    VCR.use_cassette("fb_scraping_one_page") do
      assert_difference "PostComment.count", 4  do
        post.scraping_comments
      end
    end
  end

  test "scraping log " do
    post = posts(:three)
    VCR.use_cassette("fb_scraping") do
      assert_difference "ScrapingLog.count"  do
        post.scraping_comments
      end
    end
  end
end
