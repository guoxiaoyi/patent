class ExpireResourcePackJob < ApplicationJob
  queue_as :default

  def perform(resource_pack_id)
    resource_pack = ResourcePack.find_by(id: resource_pack_id)
    return unless resource_pack && resource_pack.active?

    resource_pack.update(status: :expired)
  end
end
