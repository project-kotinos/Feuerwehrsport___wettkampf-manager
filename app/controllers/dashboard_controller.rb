class DashboardController < ApplicationController
  before_action do
    redirect_to(presets_path) unless Competition.one.configured?
  end

  def show
    default_meta_description title: "#{Competition.one.name} - #{l Competition.one.date} - Wettkampf-Manager"
  end

  def impressum
    default_meta_description title: "#{Competition.one.name} - Wettkampf-Manager - Impressum"
  end

  def flyer
    send_pdf(Exports::PDF::Flyer, filename: 'flyer.pdf', format: nil)
  end

  def create_backup
    authorize!(:manage, Competition.first)

    path ||= Competition.first.backup_path.presence
    path ||= Rails.root.join('backups')
    path = File.join(path, Time.current.strftime('%Y%m%d-%H%M%S'))

    Exports::FullDump.new.to_path(path)

    flash[:success] = "Backup wurde unter dem Pfad »#{path}« gespeichert."
    redirect_to root_path
  end
end
