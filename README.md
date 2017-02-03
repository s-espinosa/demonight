[![Stories in Ready](https://badge.waffle.io/s-espinosa/demonight.png?label=ready&title=Ready)](https://waffle.io/s-espinosa/demonight)
# DEMO NIGHT!

A basic voting application for competitions currently designed for the [Turing School of Software & Design](https://www.turing.io/) student demo night competition.

This is a Ruby on Rails application using GitHub authentication. [Figaro](https://github.com/laserlemon/figaro) has been used to manage environment variables.

In order to run this project in a dev/production environment you will need to [register two GitHub applications](https://github.com/settings/applications/new), fork the project on GitHub, clone your new repository (available at `https://github.com/YOUR_USERNAME_HERE/demonight`), `cd` into the project directory in your terminal, and enter the following from the command line.

```
bundle
gem install figaro
bundle exec figaro install
```

That should create a `/config/application.yml` file in your project, and should add it to your `.gitignore`. We recommend that you check to ensure that file has been ignored. If you run `git status` at this point it should not show up as a file to be staged.

A sample `application.yml` file for use with Figaro is included in `/config/sample_application.yml`. Copy those contents to your newly created `application.yml` file and enter your keys. Use `figaro heroku:set -e production` to set your keys on Heroku. Additional information available in the Figaro, GitHub OAuth, and Heroku docs.
