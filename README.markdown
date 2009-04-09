# Make Gem Now

A tool to scan through a whole bunch of checked out repos and build gems for them as needed. It will then index those gems, and make them available for download.

## Usage:

    make-gem-now path/to/my/code  /var/www/gems

Simple no?


## Callbacks:

Create a `~/.make-gem-now-rc.rb` file and define as many callbacks as you like in it. They can be as simple or as contrived as you like!

### Example
    MakeGemNow::Builder.on_build do |builder|
      puts "I Built #{builder.spec.name} v#{builder.spec.version}"
    end

Now you can run your own github!
