class Payment < ApplicationRecord
  belongs_to :order

  enum status_bank: { pendente_de_cobranca: '01', cobranca_efetivada_com_sucesso: '05', 
                      cobranca_recusada_por_falta_de_creditos: '09', cobranca_recusada_por_dados_incorretos_para_cobranca: '10',
                      cobranca_recusada_sem_motivo_especificado: '11'}
  enum status: {analise: 1, rejeitado: 2, aprovado: 3}      
  
  before_create :set_token

  private
  
  def set_token
    self.token = SecureRandom.hex(10)
    set_token if Payment.exists?(token: token)
  end
end
