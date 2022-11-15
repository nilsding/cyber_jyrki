# cyber_jyrki

A telegram bot.

## Installation

build it:

```
shards build
```

first-time configuration:

```sh
# create environment file containing the configuration
echo "TELEGRAM_API_KEY=1234567890:abcdefghijklmnop..." > .env
echo "FUR_AFFINITY_COOKIE_A=a04bfec6-4836-4041-b9bf-9749e3fb17bc" >> .env
echo "FUR_AFFINITY_COOKIE_B=875bc28b-6f9c-49af-b744-36a482352a47" >> .env
echo "IMGUR_CLIENT_ID=1234567890abcde" >> .env
```

note: to make the bot work in groups you need to **disable** the "privacy mode"
for your bot.  this can be done by using the `/setprivacy` command with
`@BotFather`.

## Usage

once built:

```sh
# run the bot
./bin/cyber_jyrki
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/nilsding/cyber_jyrki/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Georg Gadinger](https://github.com/nilsding) - creator and maintainer
