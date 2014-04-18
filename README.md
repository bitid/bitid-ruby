# BitID

This is the ruby implementation of the BitID authentication protocol. Basicaly, what the Gem does is
building a message challenge and verifying the signature.

## Installation

Add this line to your application's Gemfile:

    gem 'bitid-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitid-ruby

## Usage

### Challenge

To build a challenge, you need to initialize a `Bitid` object with a `nonce` and a `callback`.

```
bitid = Bitid.new(nonce:@nonce, callback:@callback)
```

`nonce` is an random string associated with the user's session id.
`callback` is the url where the wallet will post the challenge's signature.

Once the `Bitid` object is initialized, you have access to the following methods :

```
bitid.uri
```

This is the uri which will trigger the wallet when clicked (or scanned as QRcode). For instance :

```
bitid://bitid-demo.herokuapp.com/callback?x=987f20277c015ce7
```

```
bitid.qrcode
```

The same uri, but on QRcode format (this is actualy an URL pointing to the QRcode image).

### Verification

When getting the callback from the wallet, you must initialize a `Bitid` object with the received 
parameters `address`, `uri`, `signature` as well as the excpected `callback` :

```
bitid = Bitid.new(address:@address, uri:@uri, signature:@signature, callback:@callback)
```

You can after call the following methods :

```
bitid.nonce
```

Return the `nonce`, which would get you the user's session.

```
bitid.uri_valid?
```

Returns `true` if the submitted URI is valid and corresponds to the correct `callback` url.

```
bitid.signature_valid?
```

If returns `true`, then you can authenticate the user's session with `address` (public Bitcoin
address used to sign the challenge).


## Integration example

Ruby on Rails application using the bitid gem :
https://github.com/bitid/bitid-demo

Live demonstration :
http://bitid-demo.herokuapp.com/


## Author

Eric Larchevêque
elarch@gmail.com

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
