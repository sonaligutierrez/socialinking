namespace :scraping do

  desc "Run all post scraping"
  task start: :environment do
    Post.all.each do |post|
      begin
        puts "Proccesing: #{post.title} (#{post.id})"
        count = post.scraping
        puts "Procesados: #{count} comments"
      rescue Exception => e
        puts e.message
      end
    end
  end

  desc "Run all post scraping asincronaly"
  task async_start: :environment do
    Post.all.each do |post|
      begin
        hours_diff = (Time.parse(DateTime.now.to_s) - Time.parse(post.created_at.to_s))/3600
        if hours_diff > 24.0
          if post.id.odd? && DateTime.now.hour > 12
            puts "Programming: #{post.title} (#{post.id})"
            count = ExtractDataInBatchJob.set(wait: 1.second).perform_later post
          end
          if !post.id.odd? && DateTime.now.hour <= 12
            puts "Programming: #{post.title} (#{post.id})"
            count = ExtractDataInBatchJob.set(wait: 1.second).perform_later post
          end
        else
        end
      rescue Exception => e
        puts e.message
        Rollbar.error(e.message)
      end
    end
  end

end
