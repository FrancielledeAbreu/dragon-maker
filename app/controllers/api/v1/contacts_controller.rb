class Api::V1::ContactsController < AuthenticatedController
  before_action :set_user
  before_action :set_contact, only: %i[show destroy update]

  def index
    render_json(@user.contacts)
  end

  def create
    contact = @user.contacts.build(contact_params)
    contact.save ? render_json(contact, :created) : render_error(contact.errors.full_messages)
  end

  def show
    render_json(@contact)
  end

  def destroy
    @contact.destroy ? render_message('Contact deleted successfully') : render_error('Failed to delete contact')
  end

  def update
    if @contact.update(contact_params)
      render_message('Contact updated successfully')
    else
      render_error(@contact.errors.full_messages)
    end
  end

  def search
    conditions = []
    values = {}

    if params[:name].present?
      conditions << 'name ILIKE :name'
      values[:name] = "%#{params[:name]}%"
    end

    if params[:cpf].present?
      conditions << 'cpf ILIKE :cpf'
      values[:cpf] = "%#{params[:cpf]}%"
    end

    if conditions.empty?
      render_error('No valid search parameters provided', :bad_request)
      return
    end

    contacts = @user.contacts.where(conditions.join(' AND '), values)

    contacts.empty? ? render_error('No contacts found for the provided search criteria') : render_json(contacts)
  end

  private

  def set_user
    @user = current_user
  end

  def set_contact
    @contact = @user.contacts.find(params[:id])
  end

  def contact_params
    params.require(:contact)
          .permit(:name, :email, :cpf, :phone, :address_id,
                  :street_number, :complement, :latitude, :longitude)
  end

  def render_json(data, status = :ok)
    render json: data, status:
  end

  def render_message(message, status = :ok)
    render json: { message: }, status:
  end

  def render_error(errors, status = :unprocessable_entity)
    render json: { error: errors.is_a?(Array) ? errors.join(', ') : errors }, status:
  end
end
