## Contact form for Middleman

Simple sinatra application, intended for heroku to send emails from a static middleman app deployed on s3 with CORS enabled.

### Instructions

    heroku create website-contact
    heroku addons:add sendgrid:starter
    heroku config:set email_recipients=you@website.com
    heroku config:set email_subject="[WEBSITE] New contact from website"
    heroku config:set website_url=http://www.website.com

You will then be able to send `POST` request with the following params:

* name
* email
* message
* phone

Inspired from [middle-contact-form](https://github.com/evantravers/middleman-contact-form) (which didn't seemed to work properly :s) and added the CORS management in order to provide feedback to the users.