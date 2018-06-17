class PagesController < ApplicationController
  def home
    @versions = Version.order("created_at DESC").limit(5) # .joins('INNER JOIN users ON "whodunnit"= cast(users."id" as text)')
    @versions.each do |version|
      version.whodunnit = User.find(version.whodunnit).username || '(anonymous)'
    end
  end
end
