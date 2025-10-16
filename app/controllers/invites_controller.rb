class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invite, only: [:accept, :decline, :show]

  # Zeigt alle Einladungen für den aktuellen User
  def index
    @invites = current_user.invites.includes(:event).order(created_at: :desc)
  end

  # Zeigt Details zu einer Einladung
  def show
  end

  # Einladung annehmen
  def accept
    @invite.accepted!
    redirect_to invites_path, notice: "Du hast die Einladung angenommen."
  end

  # Einladung ablehnen
  def decline
    @invite.declined!
    redirect_to invites_path, alert: "Du hast die Einladung abgelehnt."
  end

  private

  def set_invite
    @invite = current_user.invites.find(params[:id])
  end
end
