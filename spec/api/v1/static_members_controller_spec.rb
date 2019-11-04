RSpec.describe 'StaticMembers API' do
  describe 'DELETE#destroy' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:guild) { create :guild }
      let!(:character) { create :character, guild: guild, user: user }
      let(:access_token) { JwtService.new.json_response(user: user)[:access_token] }

      context 'for unexisted static member' do
        before { delete '/api/v1/static_members/unexisted.json', params: { access_token: access_token } }

        it 'returns status 400' do
          expect(response.status).to eq 400
        end

        it 'and returns error message' do
          expect(JSON.parse(response.body)).to eq('error' => 'Object is not found')
        end
      end

      context 'for existed static member' do
        let!(:static) { create :static, staticable: guild, world: character.world, fraction: character.race.fraction }
        let!(:static_member) { create :static_member, static: static, character: character }

        context 'for unavailable static member' do
          before { delete "/api/v1/static_members/#{static_member.id}.json", params: { access_token: access_token } }

          it 'returns status 400' do
            expect(response.status).to eq 400
          end

          it 'and returns error message' do
            expect(JSON.parse(response.body)).to eq('error' => 'Forbidden')
          end
        end

        context 'for available static member' do
          let!(:guild_role) { create :guild_role, guild: guild, character: character, name: 'gm' }
          before { delete "/api/v1/static_members/#{static_member.id}.json", params: { access_token: access_token } }

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          it 'and returns result message' do
            expect(JSON.parse(response.body)).to eq('result' => 'Static member is destroyed')
          end
        end
      end
    end

    def do_request(headers = {})
      delete '/api/v1/static_members/unexisted.json', headers: headers
    end
  end
end
