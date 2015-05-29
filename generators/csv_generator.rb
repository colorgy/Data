require 'csv'
require 'json'
require 'pry'
require 'spreadsheet'
##
#
#
class CsvGenerator

  def generate filename, opts = {}
    @courses = File.exist?(filename) ? JSON.parse(File.read(filename)) : @courses = []

    if not @courses.empty?
      @courses.map{|cor| cor["department"]}.uniq.each do |department|
        selected_courses = select_courses_by(department: department)
        department = "不分系所" if department.empty?

        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet name: '課程列表'

        # write table header
        sheet.row(0).concat \
          %w(系所 代碼 課程名稱 授課教師 書籍ISBN 已確認 版次 作者 出版商 代理商 價格)

        columns = ["department", "code", "name", "lecturer"]
        selected_courses.each_with_index do |course, index|
          arr = columns.map{|key| course[key]}.concat(["", ""])
          sheet.row(index+1).concat arr
        end

        # write files
        output_folder = opts[:output_folder] || 'output'
        department_folder = File.join(output_folder, department)
        cover_folder = File.join(output_folder, department, '用書封面')

        Dir.mkdir(output_folder) if not Dir.exist?(output_folder)
        Dir.mkdir(department_folder) if not Dir.exist?(department_folder)
        Dir.mkdir(cover_folder) if not Dir.exist?(cover_folder)

        book.write File.join(output_folder, department, "#{department}.xls")

      end
    end
  end

  private
    def select_courses_by opts = {}
      return @courses if opts.empty?
      return @courses.select do |course|
        opts.inject(true) { |c, (h, v)| c = c && (course[h.to_s] == v) }
      end
    end
end

CsvGenerator.new.generate(ARGV[0], output_folder: ARGV[1])
