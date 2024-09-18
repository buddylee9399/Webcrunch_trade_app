# Ruby on Rails #58 Nested Resources

- https://www.youtube.com/watch?v=p1bAVf6T58I
- https://guides.rubyonrails.org/routing.html#nested-resources
- https://github.com/corsego/58-nested-resources/commit/9885432f93f1c5af100e10edc57d8f3358527738
- rails g scaffold inbox title
- rails g scaffold message title inbox:references
- rails db:migrate
- update inbox.rb

```
class Inbox < ApplicationRecord
  has_many :messages, dependent: :destroy
end
```

- update routes

```
  resources :inboxes do
    resources :messages, module: :inboxes
  end
```

- move the messages folder in the inboxes folder
- create the folder controllers/inboxes
- create the file: app/controllers/inboxes/messages_controller.rb

```
class Inboxes::MessagesController < ApplicationController
  before_action :set_inbox
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    # @messages = Message.all
    @messages = @inbox.messages
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = @inbox.messages.build
    # @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json
  def create
    # @message = Message.new(message_params)
    @message = @inbox.messages.build(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to [@inbox, @message], notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to [@inbox, @message], notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to [@inbox, :messages], notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_inbox
      @inbox = Inbox.find(params[:inbox_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      # @message = Message.find(params[:id])
      @message = @inbox.messages.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:title)
    end
end
```

- update inboxes/messages/new

```
<h1>New message</h1>

<%= render "form", message: @message %>

<br>

<div>
  <%= link_to "Back to messages", inbox_messages_path(@inbox) %>
</div>
```

- update inboxes/messages/edit

```
<h1>Editing message</h1>

<%= render "form", message: @message %>

<br>

<div>
  <%= link_to "Show this message", [@inbox, @message] %> |
  <%= link_to "Back to messages", inbox_messages_path(@inbox) %>
</div>
```

- update inboxes/messages/show

```
<p id="notice"><%= notice %></p>

<%= render @message %>

<div>
  <%= link_to "Edit this message", edit_inbox_message_path([@inbox, @message]) %> |
  <%= link_to "Back to messages", [@inbox, :messages] %>

  <%= button_to "Destroy this message", [@inbox, @message], method: :delete %>
</div>
```

- update inboxes/messages/message partial

```
<div id="<%= dom_id message %>" class="scaffold_record">
  <p>
    <strong>Title:</strong>
    <%= message.title %>
  </p>

  <p>
    <strong>Inbox:</strong>
    <%= message.inbox_id %>
  </p>

  <p>
    <%= link_to "Show this message", [@inbox, message] %>
  </p>
</div>
```

- updaet inboxes/messages/index

```
<p id="notice"><%= notice %></p>

<h1>Message</h1>

<div id="messages">
  <%= render @messages %>
</div>

<%= link_to "New message", new_inbox_message_path %>
```

- NOT FULLY FINISHED BUT ITS COOL THE FOLDERS NESTED IN THEIR PARENT FOLDER
