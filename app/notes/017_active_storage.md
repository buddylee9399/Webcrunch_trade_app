# Active Storagre

- https://guides.rubyonrails.org/active_storage_overview.html

```
bin/rails active_storage:install
bin/rails db:migrate
```

```
class User < ApplicationRecord
  has_one_attached :avatar
end
```

```
<%= form.file_field :avatar %>
```

```
  private
    def user_params
      params.require(:user).permit(:email_address, :password, :avatar)
    end
```

```
user.avatar.attached?
```

```
class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
```

```
class Message < ApplicationRecord
  has_many_attached :images
end
```

```
  private
    def message_params
      params.require(:message).permit(:title, :content, images: [])
    end
```

```
@message.images.attached?

```

```
class Message < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
```

### getting the url of the blob

```
  <div class="g-flex-centered g-height-100vh g-min-height-500--md g-bg-cover g-bg-pos-center g-bg-img-hero g-bg-black-opacity-0_5--after" style="background-image: url('<%= rails_blob_path(promo.promo_image) %>');">
```

## how to add verification