class Api::V1::ContactsController < AuthenticatedController
  before_action :set_user
  before_action :set_contact, only: %i[show destroy update]

  def index
    render json: @user.contacts, status: :ok
  end

  def create
    contact = @user.contacts.build(contact_params)

    if contact.save
      render json: contact, status: :created
    else
      render json: { error: 'Failed to create contact', details: contact.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    render json: @contact, status: :ok
  end

  def destroy
    if @contact.destroy
      render json: { message: 'Contact deleted successfully' }, status: :ok
    else
      render json: { error: 'Failed to delete contact' }, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      render json: { message: 'Contact updated successfully' }, status: :ok
    else
      render json: { error: @contact.errors.full_messages }, status: :unprocessable_entity
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
      render json: { error: 'No valid search parameters provided' }, status: :bad_request
      return
    end

    contacts = @user.contacts.where(conditions.join(' AND '), values)

    if contacts.empty?
      render json: { error: 'No contacts found for the provided search criteria' }, status: :not_found
    else
      render json: contacts, status: :ok
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_contact
    @contact = @user.contacts.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :cpf, :phone, :address_id, :street_number,
                                    :complement, :latitude, :longitude)
  end
end
