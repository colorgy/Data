#!/usr/bin/env ruby

# Usage:
# ./isbn_importer.rb {organization directory} {organization code, optional}

require 'spreadsheet'
require 'pry'
require 'json'

require_relative './isbn_importer/organization'

module IsbnImporter

  class << self
    def convert directory=nil
      course_book_data = []

      if directory.nil?
        puts "not assign target directory, run command as \"./isbn_importer {PATH_HERE}\""
        return
      end

      organization_code = ARGV[1]

      directory.match( %r{(\d+\_)?(?<c>#{ORGANIZATION.keys.map{|k| "(#{k})"}.join('|')})} ) do |m|
        organization_code ||= m[:c].upcase
      end

      if organization_code.nil?
        puts "error directory naming, or organization not in list, or wrong directory"
        return
      end

      Dir.glob(File.join(directory, '**', '*.xls')).each do |xls|
        course_sheet = Spreadsheet.open(xls)

        course_sheet.worksheet(0).each 1 do |row| # skip 1st row
          # each row should contains:
          # 系所 代碼 課程名稱 授課教師 書籍ISBN 已確認 版次 作者 出版商 代理商 價格

          # course_ucode / book_isbn
          # course_ucode = "#{organization_code}-#{row[1]}"
          # CourseBook.first_or_create()
          isbn = row[4]
          next if isbn.nil?

          course_book = {
            code: row[1],
            course_ucode: "#{organization_code}-#{row[1]}",
            course_name: row[2],
            isbn: isbn,
            confirmed: row[5],
            edition: row[6],
            author: row[7],
            publisher: row[8],
            known_supplier: row[9],
            price: row[10]
          }

          course_book_data << course_book
        end # end each row(course)
      end # end each xls

      Dir.mkdir 'import_ready' if not Dir.exist?('import_ready')
      File.write(File.join('import_ready', "#{Pathname.new(directory).basename}.json"), JSON.pretty_generate(course_book_data))

    end # end convert method

    def batch_convert parent_dir=nil
      Dir.glob(File.join(parent_dir, '*')).select{|f| File.directory? f}.each{ |d| convert(d) }
    end
  end
end

# IsbnImporter.convert( ARGV[0] )
IsbnImporter.batch_convert( ARGV[0] )
