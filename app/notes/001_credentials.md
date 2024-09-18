# Credentials

- Website tutorial: master key with heroku -https://dev.to/raaynaldo/the-power-of-rails-master-key-36fh
- From course go: - https://blog.corsego.com/ruby-on-rails-6-credentials-tldr

# Ruby on Rails #18 Encrypted Credentials and Global Variables (+ VIM basics)

- https://www.youtube.com/watch?v=nDJE8WG0auE&t=10s

- Use the master key of the computer that originally uploaded the file to GitHub

- EDITOR='subl -w' bin/rails credentials:edit

```
development:
  stripe:
    # publication key:
    public_key: 1234qwer
    # secret key:
    private_key: 1234qwer
    signing_secret: 1234qwer

  aws:
    access_key_id: 1234qwer
    secret_access_key: 1234qwer
    region: region
    bucket: bucket

production:
  stripe:
    # publication key:
    public_key: 1234qwer
    # secret key:
    private_key: 1234qwer
    signing_secret: 1234qwer

  aws:
    access_key_id: 1234qwer
    secret_access_key: 1234qwer
    region: region
    bucket: bucket
```

* In rails console

```
Rails.application.credentials.dig(Rails.env.to_sym, :stripe, :public_key)
```
