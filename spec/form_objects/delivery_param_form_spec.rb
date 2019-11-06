RSpec.describe DeliveryParamForm, type: :service do
  describe '.persist?' do
    context 'for invalid data' do
      let(:service) { DeliveryParamForm.new(delivery: nil, params: {}) }

      it 'does not create new delivery param' do
        expect { service.persist? }.to_not change(DeliveryParam, :count)
      end

      it 'and returns false' do
        expect(service.persist?).to eq false
      end
    end

    context 'for empty discord webhook param' do
      let!(:delivery) { create :delivery }
      let(:service) { DeliveryParamForm.new(delivery: delivery, params: {}) }

      it 'does not create new delivery param' do
        expect { service.persist? }.to_not change(DeliveryParam, :count)
      end

      it 'and returns false' do
        expect(service.persist?).to eq false
      end
    end

    context 'for invalie discord webhook param' do
      let!(:delivery) { create :delivery }
      let(:service) { DeliveryParamForm.new(delivery: delivery, params: { 'id' => '', token: 123 }) }

      it 'does not create new delivery param' do
        expect { service.persist? }.to_not change(DeliveryParam, :count)
      end

      it 'and returns false' do
        expect(service.persist?).to eq false
      end
    end

    context 'for valid data' do
      let!(:delivery) { create :delivery }
      let(:service) { DeliveryParamForm.new(delivery: delivery, params: { 'id' => 123, 'token' => '123' }) }

      context 'for existed delivery param' do
        let!(:delivery_param) { create :delivery_param, delivery: delivery }

        it 'does not create new delivery param' do
          expect { service.persist? }.to_not change(DeliveryParam, :count)
        end

        it 'and returns false' do
          expect(service.persist?).to eq false
        end
      end

      context 'for unexisted delivery param' do
        it 'creates new delivery param' do
          expect { service.persist? }.to change { DeliveryParam.count }.by(1)
        end

        it 'and returns true' do
          expect(service.persist?).to eq true
        end
      end
    end

    context 'for update' do
      let!(:delivery_param1) { create :delivery_param }
      let!(:delivery_param2) { create :delivery_param }

      context 'for unexisted delivery param' do
        let(:service) { DeliveryParamForm.new(id: 999, params: {}) }

        it 'returns false' do
          expect(service.persist?).to eq false
        end
      end

      context 'for existed delivery param' do
        context 'for invalid data' do
          let(:service) { DeliveryParamForm.new(id: delivery_param1.id, delivery: delivery_param1.delivery, params: { 'id' => '0' }) }

          it 'does not update delivery param' do
            service.persist?
            delivery_param1.reload

            expect(delivery_param1.params).to_not eq('id' => '0')
          end
        end

        context 'for existed data' do
          let(:service) { DeliveryParamForm.new(id: delivery_param1.id, delivery: delivery_param2.delivery, params: delivery_param1.params) }

          it 'does not update delivery param' do
            service.persist?
            delivery_param1.reload

            expect(delivery_param1.delivery).to_not eq delivery_param2.delivery
          end
        end

        context 'for valid data' do
          let(:service) { DeliveryParamForm.new(id: delivery_param1.id, delivery: delivery_param1.delivery, params: { 'id' => 123, 'token' => '123' }) }

          it 'does not update delivery param' do
            service.persist?
            delivery_param1.reload

            expect(delivery_param1.params).to eq('id' => 123, 'token' => '123')
          end
        end
      end
    end
  end
end