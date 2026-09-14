\# Дипломный проект: Автоматизация развёртывания веб-инфраструктуры в Yandex Cloud



Дипломная работа по развёртыванию отказоустойчивой веб-инфраструктуры

с использованием Infrastructure as Code (Terraform + Ansible).



\## 📋 Содержание



\- \[Архитектура](#архитектура)

\- \[Технологии](#технологии)

\- \[Структура репозитория](#структура-репозитория)

\- \[Быстрый старт](#быстрый-старт)

\- \[Скриншоты](#скриншоты)



\## 🏗️ Архитектура



!\[Архитектура](docs/architecture.png)



\*\*Компоненты:\*\*

\- \*\*VPC\*\* `diploma-vpc` — 3 подсети (public + 2 private) в зонах `ru-central1-a/b`

\- \*\*Bastion host\*\* — единственная точка входа для SSH

\- \*\*Application Load Balancer\*\* — балансировка L7 на 2 веб-сервера

\- \*\*2 веб-сервера\*\* (Nginx) — в приватных подсетях, в разных зонах доступности

\- \*\*Zabbix\*\* — мониторинг (в Docker), агенты на всех хостах

\- \*\*Elasticsearch + Kibana\*\* — централизованное логирование (в Docker)

\- \*\*Filebeat\*\* — сбор логов Nginx с веб-серверов

\- \*\*NAT-шлюз\*\* — исходящий интернет для приватных подсетей

\- \*\*Снапшоты\*\* — ежедневное резервное копирование (retention 7 дней)



\## 🛠️ Технологии



| Технология | Назначение |

|---|---|

| \*\*Terraform\*\* | Описание и создание инфраструктуры (IaC) |

| \*\*Ansible\*\* | Конфигурация серверов, установка сервисов |

| \*\*Yandex Cloud\*\* | Облачная платформа (Compute, VPC, ALB) |

| \*\*Nginx\*\* | Веб-сервер |

| \*\*Zabbix\*\* | Мониторинг (Docker) |

| \*\*Elasticsearch + Kibana + Filebeat\*\* | Логирование (ELK Stack, Docker) |

| \*\*Docker Compose\*\* | Оркестрация сервисов Zabbix и ELK |



\## 📂 Структура репозитория



\\`\\`\\`

.

├── terraform/          # Инфраструктура как код

├── ansible/            # Управление конфигурацией

└── docs/               # Документация и скриншоты

\\`\\`\\`



\## 🚀 Быстрый старт



\### Предварительные требования



1\. \*\*Yandex Cloud CLI\*\*: \[инструкция](https://cloud.yandex.ru/docs/cli/quickstart)

2\. \*\*Terraform\*\* >= 1.0: \[инструкция](https://developer.hashicorp.com/terraform/downloads)

3\. \*\*SSH-ключ\*\* `\~/.ssh/id\_ed25519`



\### Шаг 1. Настройка сервисного аккаунта



\\`\\`\\`bash

\# Создать сервисный аккаунт

yc iam service-account create --name terraform-sa



\# Назначить роль editor

yc resource-manager folder add-access-binding \\\\

&#x20; --id <FOLDER\_ID> \\\\

&#x20; --role editor \\\\

&#x20; --service-account-name terraform-sa



\# Создать авторизованный ключ

yc iam key create \\\\

&#x20; --service-account-name terraform-sa \\\\

&#x20; --output key.json

\\`\\`\\`



\### Шаг 2. Развёртывание инфраструктуры



\\`\\`\\`bash

cd terraform



\# Скопировать пример переменных

cp terraform.tfvars.example terraform.tfvars

\# Отредактировать terraform.tfvars (cloud\_id, folder\_id)



\# Инициализация

terraform init



\# План

terraform plan



\# Применение (создание 25 ресурсов, \~15 минут)

terraform apply



\# Сохранить outputs

terraform output

\\`\\`\\`



\### Шаг 3. Настройка серверов через Ansible



\\`\\`\\`bash

\# Скопировать SSH-ключ на bastion

scp \~/.ssh/id\_ed25519 ubuntu@<BASTION\_IP>:\~/.ssh/id\_ed25519



\# Войти на bastion

ssh ubuntu@<BASTION\_IP>



\# Внутри bastion:

cd \~/ansible

ansible all -m ping              # проверка связи



\# Запустить плейбуки

ansible-playbook -i inventory.ini playbooks/web/web.yml

ansible-playbook -i inventory.ini playbooks/zabbix/zabbix-docker.yml

ansible-playbook -i inventory.ini playbooks/zabbix-agent/zabbix-agent.yml

ansible-playbook -i inventory.ini playbooks/elasticsearch/elasticsearch.yml

ansible-playbook -i inventory.ini playbooks/kibana/kibana.yml

ansible-playbook -i inventory.ini playbooks/filebeat/filebeat.yml

\\`\\`\\`



\## 📸 Скриншоты



\### Terraform

!\[terraform apply](docs/screenshots/01-terraform-apply.png)



\### Сайт через ALB

!\[Nginx site](docs/screenshots/04-nginx-site.png)



\### Zabbix

!\[Zabbix dashboard](docs/screenshots/06-zabbix-dashboard.png)



\### Kibana

!\[Kibana dashboard](docs/screenshots/10-kibana-dashboard.png)







