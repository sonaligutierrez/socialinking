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

# Config Facebook User for scraping

The facebook user sessions used by scraping process are in files in the folder `docs/fb_users`.

There are login and pasword info and session files (json). This sessions info should by inserte in `FbSession` model in the field `name`. 

The register must be like this:
```
 => #<FbSession id: 1, name: "[{\"name\":\"presence\",\"value\":\"EDvF3EtimeF1546207185...", created_at: "2018-09-26 19:41:51", updated_at: "2018-12-30 21:59:47", disabled: false, login: "100024268843643", pass: "123gwapako", proxy_id: 1> 
```

You can always take a look at test fixtures files, especialy `fb_sessions.yml` to a better understanding of this configuration.
