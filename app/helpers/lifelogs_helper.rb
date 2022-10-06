module LifelogsHelper
  include ApplicationHelper
  #   viewで見たいカラムをオプションで提示する
  # この関数を記入すると、オプションに対応したカラム名とvalueが帰ってくる
  # 引数に入れた変数typeによって、カラムを返すのかvalueを返すのか決める
  #  ダリーからとりま全部のカラム返すわ、リファクタリングの時にまたやれ
  def return_optional_value_of_lifelog(_type)
    view_columns = %i[post_type start_datetime]
    @result = []
    view_columns.each do |column|
      push_value = column.to_s if _type == 'column'
      @result.push(push_value)
      next unless _type == 'value'

      @microposts.each do |micropost|
        @result.push(micropost[column])
      end
    end
    # test = :title
    # result = @lifelog[test]
    # オプションをシンボルにして記入して、eachで取り出してcolumを更新、あとはtypeに応じて出しわけ
    # type = %(colum, value)
  end
end
