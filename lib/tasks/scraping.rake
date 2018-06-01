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

end
