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
  task asincrono_start: :environment do
    Post.all.each do |post|
      begin
        puts "Proccesing: #{post.title} (#{post.id})"
        ExtractDataInBatchJob.set(wait: 1.second).perform_later post
      rescue Exception => e
        puts e.message
      end
    end
  end

end
