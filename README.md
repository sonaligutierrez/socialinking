# Social Linking

The goal of this web based app its to get facebook comments from a facebook post. and then operators will manually read them and categorize
For each comment we will need to get the Username, Fullname, Time and Comment.
For categorizing, users will have to enter to a previously downloaded posts, and explore each comment, and categorize it based on previously defined categories.
We will have user roles, but with this first version just one role that can define a facebook post to scrape, and then categorize the comments.

# Development Environment

- Clone project
- `cd social_linking`
- `gem install`
- create databases: `social_linking_development`, `social_linking_test`
- Change `database.yml` with conections credentials.
- `rails s`
