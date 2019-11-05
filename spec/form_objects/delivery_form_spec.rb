RSpec.describe DeliveryForm, type: :service do
  describe '.persist?' do
    context 'for invalid data' do
      let(:service) { DeliveryForm.new(guild: nil, notification: nil) }

      it 'does not create new delivery' do
        expect { service.persist? }.to_not change(Delivery, :count)
      end

      it 'and returns false' do
        expect(service.persist?).to eq false
      end
    end

    context 'for valid data' do
      let!(:delivery) { create :delivery }

      context 'for existed delivery' do
        let(:service) { DeliveryForm.new(guild: delivery.guild, notification: delivery.notification, delivery_type: delivery.delivery_type) }

        it 'does not create new delivery' do
          expect { service.persist? }.to_not change(Delivery, :count)
        end

        it 'and returns false' do
          expect(service.persist?).to eq false
        end
      end

      context 'for unexisted delivery' do
        let!(:guild) { create :guild }
        let!(:notification) { create :notification }
        let(:service) { DeliveryForm.new(guild: guild, notification: notification, delivery_type: 0) }

        it 'creates new delivery' do
          expect { service.persist? }.to change { Delivery.count }.by(1)
        end

        it 'and returns true' do
          expect(service.persist?).to eq true
        end
      end
    end
  end
end
