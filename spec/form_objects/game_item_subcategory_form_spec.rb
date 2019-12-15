RSpec.describe GameItemSubcategoryForm, type: :service do
  describe '.persist?' do
    context 'for invalid data' do
      let(:service) { described_class.new(uid: '', name: { 'en' => '', 'ru' => '' }) }

      it 'does not create new object' do
        expect { service.persist? }.to_not change(GameItemSubcategory, :count)
      end

      it 'and returns false' do
        expect(service.persist?).to eq false
      end
    end

    context 'for valid data' do
      let(:service) { described_class.new(uid: 7, name: { 'en' => 'Metal & Stone', 'ru' => 'Металл и камни' }) }

      it 'creates new object' do
        expect { service.persist? }.to change { GameItemSubcategory.count }.by(1)
      end

      it 'and returns true' do
        expect(service.persist?).to eq true
      end
    end
  end
end