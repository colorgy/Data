Colorgy Data
============

# 資料格式說明


由三大部分組成，課程資料、教授資料、書資料。

## 系所資料
各系 *學號規則*、系所英文名稱、系所英文縮寫、系所中文縮寫等。

### 學號規則
將會用於 Colorgy 系統註冊時的 *學號辨識*。

------------------------------

## 課程資料
收集方式為 *程式爬蟲*，*課程用書*欄位資料需要人工完成。

將該系課程之用書資料整理為表格，欄位如下：

```
課程序號（課程代碼）、課程名稱，書籍 ISBN，書名、版次、書籍封面、已確認（是/否）
```

### 課程序號
也可能是課程代碼，每堂課唯一的編碼，統一由 MISK 方指派。

### 書籍 ISBN（必填）
填 10 碼或 13 碼皆可。格式統一整齊。

### 書籍封面
供 MISK 核對資料正確性，照片或圖片需命名為 isbn ，例如 xxxx.png

需提供清晰正面照乙張。

### 其餘書籍資料

* 版次、作者、出版商、代理商、價格。

儘量完整即可。

### 已確認
是否有找教授本人親自確認過書籍的正確性，若有填[是]，沒有則填[否]。

### 範例

資料夾結構：
![example](images/example.png)
```
├── 人類系
│   ├── 人類系.xls
│   └── 用書封面
```

檔案範例：
![example2](images/example2.png)

------------------------------

## 教授資料
資料格式如下

![instructors](images/instructors.png)


# Script Tools

放在 tools 資料夾底下，目前有兩個：

```bash
tools
├── isbn_importer
│   └── organization.rb
├── isbn_importer.rb
└── spreadsheet_generator.rb
```

## 用法 （還在更新中）

```bash
$ ./tool/spreadsheet_generator.rb INPUT_JSON_FILE.json
$ ./tool/isbn_importer.rb INPUT_FOLDER_PATH
```

`spreadsheet_generator` 的輸入 json 格式寫在 [Hackpad](https://colorgy.hackpad.com/Courses--ZacPUB7k0tB)

`isbn_importer` 的資料夾是指包含 `spreadsheet_generator` 輸出資料夾們的資料夾。這樣好像不太好懂，比如說我把產生的資料夾放在 output

```
output
├── 1031_cycu_courses
├── 1031_fju_courses
├── 1031_nchu_courses
.....
```

在用 `isbn_importer` 就這樣打

```
$ ./tool/isbn_importer.rb output
```

會把資料寫到叫 ready_import 的資料夾。

這邊都暫時的用法。
