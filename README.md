### Hexlet tests and linter status:
[![Actions Status](https://github.com/ChalcevIlya/rails-project-65/actions/workflows/hexlet-check.yml/badge.svg?branch=main)](https://github.com/ChalcevIlya/rails-project-65/actions/workflows/hexlet-check.yml)
[![Actions Status](https://github.com/ChalcevIlya/rails-project-65/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/ChalcevIlya/rails-project-65/actions/workflows/ci.yml)

## Deployed Project

https://rails-project-65-lg04.onrender.com

## Описание проекта

Доска объявлений — это веб-приложение на Ruby on Rails, которое позволяет пользователям создавать, редактировать и управлять объявлениями. Пользователи могут публиковать свои объявления, которые после отправляются на модерацию администратору. В административной панели администраторы могут просматривать, публиковать или отклонять объявления. Также создан архив для ненужных или неактуальных объявлений.

## Используемые технологии

- Ruby on Rails
- AASM (управление состояниями моделей)
- Active Storage (хранение файлов)
- Kaminari (пагинация)
- OmniAuth-GitHub (авторизация через GitHub)
- Pundit (авторизация и политики доступа)
- Ransack (расширенный поиск)
- Simple Form (работа с формами)
- Slim (шаблонизатор)

## Установка и запуск

1. Клонируйте репозиторий:

```bash
   git clone https://github.com/ChalcevIlya/rails-project-65.git
```
2. Перейдите в каталог проекта:

```bash
   cd rails-project-65
```
3. Установите зависимости и подготовьте окружение:

```bash
   make setup
```
4. Запустите приложение:

```bash
   make start
```
5. Откройте в браузере:

```bash
   http://0.0.0.0:3000
```