Active Record
 - M(model) в MVC
 - представление бизнесс логики и данных
 - active record: описание системы ORM(Object Relational Mapping)

Соглашения над конфигурацией в Active Record
- Множественное число для имен классов что бы найти соотв-ю табл. в б.д.

Модель / Класс	Таблица / Схема
Article         articles
LineItem        line_items
Deer            deers
Mouse           mice
Person          people
Book            books
BookClub        book_clubs

Валидация:
class User < ActiveRecord::Base
  validates :name, presence: true
end

rails generate migration AddPartNumberToProducts
Это создаст пустую, но правильно названную миграцию:
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
  end
end
Если имя миграции имеет форму "AddXXXToYYY" или "RemoveXXXFromYYY"
и далее следует перечень имен столбцов и их типов, то в миграции будут созданы
соответствующие выражения add_column и remove_column.
rails generate migration AddPartNumberToProducts part_number:string
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
    add_column :products, :part_number, :string
  end
end

Если вы хотите добавить индекс на новый столбец, вы можете сделать это так
rails generate migration AddPartNumberToProducts part_number:string:index
class AddPartNumberToProducts < ActiveRecord::Migration
  def change
    add_column :products, :part_number, :string
    add_index :products, :part_number
  end
end

Точно так же, вы можете сгенерировать миграцию для удаления столбца из командной строки:
rails generate migration RemovePartNumberFromProducts part_number:string
class RemovePartNumberFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :part_number, :string
  end
end



Создание таблиц:
create_table :products do |t|
  t.string :name
end
Создание соединительных таблиц:
create_join_table :products, :categories
create_join_table :products, :categories, column_options: {null: true}
create_join_table :products, :categories, table_name: :categorization
Изменение таблиц:
change_table :products do |t|
  t.remove :description, :name
  t.string :part_number
  t.index :part_number
  t.rename :upccode, :upc_code
end
Изменение столбцов:
change_column_null :products, :name, false
change_column_default :products, :approved, false

Модификаторы столбца

Модификаторы столбца могуть быть применены при создании или изменении столбца:

limit Устанавливает максимальный размер полей string/text/binary/integer.
precision Определяет точность для полей decimal, определяющую общее количество цифр в числе.
scale Определяет масштаб для полей decimal, определяющий количество цифр после запятой.
polymorphic Добавляет столбец type для связей belongs_to.
null Позволяет или запрещает значения NULL в столбце.
default Позволяет установить значение по умолчанию для столбца. Отметьте, что есливы используете
динамическое значение (такое как дату), значение по умолчанию будет вычислено лишь
один раз (т.е. на дату, когда миграция будет применена).
index Добавляет индекс для столбца.
Некоторые адаптеры могут поддерживать дополнительные опции; за подробностями обратитесь
к документации API конкретных адаптеров

Внешние ключи
add_foreign_key :articles, :authors
# позволим Active Record вычислить имя столбца
remove_foreign_key :accounts, :branches
# уберем внешний ключ для определенного столбца
remove_foreign_key :accounts, column: :owner_id
# уберем внешний ключ по имени
remove_foreign_key :accounts, name: :special_fk_name