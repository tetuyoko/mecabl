module Debug
  class ClassifierController < ActionController::Base

    def index
      @classifier = Classifier.load_classifier
    end

    def train
      # randomに取得
      @entry = Entry.where( 'id >= ?', rand(Entry.first.id..Entry.last.id) ).first
    end

    def do
      @entry = Entry.find(params[:id])
      # only create History
      flash[:notice] = if TrainHistory.create(entry_id: @entry.id, category: CategoryRecord.categories[params[:category]])
                         "#{I18n.t('classifier.categories')[params[:category].to_sym]} を学習しました!"
                       else
                         "学習失敗しました。。"
                       end

      redirect_to train_debug_classifier_index_path
    end

  end
end
