# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://developer.hashicorp.com/terraform/language/backend) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
3. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://developer.hashicorp.com/terraform/language/backend) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---

### Решение
Файлы для создания инфраструктры находятся в папке :  [bucket](https://github.com/oviplokos/netology-diplom/tree/main/bucket) 

Скриншоты созданной инфсраструктуры:
![image](https://github.com/user-attachments/assets/f1007eae-b452-4fc5-b3a8-9663f3e99dd0)
![image](https://github.com/user-attachments/assets/7c5a5f6d-d592-4483-8bf3-b13a771c3aea)
![image](https://github.com/user-attachments/assets/1e5f345d-9f96-4333-8fde-4e664854e2c6)
![image](https://github.com/user-attachments/assets/bd4f8c7d-6a16-4d85-8a32-a9fee4dc9ebb)
![image](https://github.com/user-attachments/assets/61a56c92-3922-40d6-834d-27cb37e24c5f)


Добавлено 15.02.2025 по замечаниям дипломного руководителя:

добавил проект гитхаба на terraform cloud

![image](https://github.com/user-attachments/assets/1cdb3497-5feb-468b-aabd-5930752ea3ab)
![image](https://github.com/user-attachments/assets/f5b853d3-4792-4d49-9c26-9eda10a983b4)
![image](https://github.com/user-attachments/assets/d73272d4-ab6b-41fe-ba23-8473d1892351)




### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

### Решение
 
Подготовил конфигурацию для создания одной master-ноды и нескольких worker-нод [terraform](https://github.com/oviplokos/netology-diplom/tree/main/terraform) 
Знаения для переменных неодходимо указывать в файле personal.auto.tfvars который имеет структуру:
```yaml
cloud_id = " "
folder_id = " "
zone = "ru-central1-a"
token = " "
vpc_name = "VPC-k8s"
subnet_zone = ["ru-central1-a","ru-central1-b","ru-central1-d"]
cidr = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24","10.0.0.0/24"]

master = {
    cores = 4, 
    memory = 4, 
    core_fraction = 20,  
    platform_id = "standard-v3", 
    count = 1,image_id = "fd8slhpjt2754igimqu8", 
    disk_sze = 40,
    scheduling_policy = "true"
    }

worker = {
    cores = 4, 
    memory = 4, 
    core_fraction = 20,  
    platform_id = "standard-v3", 
    count = 2,image_id = "fd8slhpjt2754igimqu8", 
    disk_sze = 40,
    scheduling_policy = "true"
    } 

bastion = {
    cores = 2, 
    memory = 2, 
    core_fraction = 20, 
    image_id = "fd8m30o437b5c6b9en6r", 
    disk_sze = 20,
    scheduling_policy = "true"
    }
```

В результате применения конфигурации,  так же атоматически создается файл с инвентарем для ansible hosts.yaml следующего вида:   
```yaml 
all:
    hosts:
        k8s-master:
            ansible_host:
            ip: 10.10.1.24
            ansible_user: netology
            ansible_ssh_common_args: -J netology@158.160.35.44

        k8s-worker-1:
            ansible_host:
            ip: 10.10.1.32
            ansible_user: netology
            ansible_ssh_common_args: -J netology@158.160.35.44
        
        k8s-worker-2:
            ansible_host:
            ip: 10.10.2.31
            ansible_user: netology
            ansible_ssh_common_args: -J netology@158.160.35.44
         
        
        
kube_control_plane:
    hosts: 
        k8s-master:
kube_node:
    hosts:
        k8s-worker-1:
        k8s-worker-2:
etcd:
    hosts: 
        k8s-master:
```
 на основе шаблона inventory.tftpl:
```
all:
    hosts:
        k8s-master:
            ansible_host:
            ip: ${k8s-master.network_interface[0].ip_address}
            ansible_user: netology
            ansible_ssh_common_args: -J netology@${bastion-nat.network_interface[0].nat_ip_address}

        k8s-worker-1:
            ansible_host:
            ip: ${k8s-worker-1.network_interface[0].ip_address}
            ansible_user: netology
            ansible_ssh_common_args: -J netology@${bastion-nat.network_interface[0].nat_ip_address}
        
        k8s-worker-2:
            ansible_host:
            ip: ${k8s-worker-2.network_interface[0].ip_address}
            ansible_user: netology
            ansible_ssh_common_args: -J netology@${bastion-nat.network_interface[0].nat_ip_address}
         
        
        
kube_control_plane:
    hosts: 
        k8s-master:
kube_node:
    hosts:
        k8s-worker-1:
        k8s-worker-2:
etcd:
    hosts: 
        k8s-master:
---

Далее был подготовлен набор ansible-ролей  [k8s](https://github.com/oviplokos/netology-diplom/tree/main/ansible/k8s)
В результате применения плейбука:   
```yaml
- name: install docker and kubectl
  hosts: all
  become: yes
  remote_user: ubuntu
  roles:
    - docker_install
    - k8s_install

- name: create cluster
  hosts: kube_control_plane
  become: yes
  remote_user: ubuntu
  roles:
    - k8s_create_cluster

- name: node invite
  hosts: kube_node
  become: yes
  remote_user: ubuntu
  roles:
    - node_invite
```
на инвентарь, полученный на предыдущем шаге, выполняется установка необходимого ПО, инициализация кластера, подключение worker-нод к кластеру и настройка kubectl .   
Применять необходимо командой *ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../hosts.yaml playbook.yml   
После выполнения плейбука захожу на мастер ноду и проверяю работоспособность кластера:
![image](https://github.com/user-attachments/assets/e0fa51c7-3f99-452b-89ef-add282f44330)


### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
## Решение:
Создал дополнительный репозиторий [github](https://github.com/oviplokos/nginx-diplom)   
Создал на DockerHub репозторий [dockerhub](https://hub.docker.com/repository/docker/oviplokos/nginx-diplom)
Создал статичную web-страницу :
```html
<html>

<head>
   <title>
      nginx-diplom
   </title>
   <meta name="title" content="nginx-diplom">
   <meta name="author" content="Donets K V">
</head>

<body>
   <pre>

  hello this is version 1.0.0
  Student Donets Konstantin


    </pre>

</body>

</html>
```
Далее создал Dockerfile:
```
FROM nginx:1.27.0
RUN rm -rf /usr/share/nginx/html/*
COPY static/index.html /usr/share/nginx/html/
EXPOSE 80

```

Создал docker образ:
![image](https://github.com/user-attachments/assets/12825a1a-32e8-4775-b1b9-1f1939b30ef9)
Запушил образ на Hub.
![image](https://github.com/user-attachments/assets/d93893e0-f8b3-4599-b2e1-987a720256a9)

Запустил контейнер:

![image](https://github.com/user-attachments/assets/90c1defc-cd84-46e7-8b6f-209c6a05ba94)

Проверяю в браузере:   

![image](https://github.com/user-attachments/assets/575a7db3-b095-4809-8c26-8bf4e3cdfcfc)


### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.

## Решение:
Доступ извне к web-интерфейсу мониторинга и приложению будет обеспечиваться по схеме балансировщик yc --> ingress ngix ---> endpoint.
Поэтому сначала устанавливаю устанавливаю ingress ngix , взял с официального сайта yaml-файл  "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml"   
Модифицировал его в секции сервиса, т.к. по умолчанию он устанавливается с сервисом LoadBalacer, а на самостоятельно развернутом кластере в YC такой тип балансировщика не работает.
Меняю тип сервиса на NodePort и настраиваю порт доступа. Балансировщик будет слушать порт 80 и перенаправлять траффик на NodePort.
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.12.0
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  externalTrafficPolicy: Local
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - appProtocol: http
    name: http
    port: 80
    protocol: TCP
    nodePort: 30080
  - appProtocol: https
    name: https
    port: 443
    protocol: TCP
    nodePort: 30443
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: NodePort
```
Применяю и проверяю:
![image](https://github.com/user-attachments/assets/e09fd9c7-4314-48a6-b5ff-dec699ee00f5)
![image](https://github.com/user-attachments/assets/477485bd-a7fb-41f4-9876-1c09af281a5c)

Для мониторинга буду использовать пакет [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus)   

Выполняю установку системы мониторинг и проверяю:

![image](https://github.com/user-attachments/assets/82cf5af0-240f-49fa-9f6c-4e0f1cf77a13)

Теперь необходимо создать балансировщик и ingress для доступа извне к веб интерфейсу графана.
https://github.com/oviplokos/netology-diplom/blob/main/terraform/balancers.tf

Изменил output , чтобы выводились внешние ip и порт балансировщика:
![image](https://github.com/user-attachments/assets/a66b7c19-88c2-494c-84d6-02995cf61b0a)

Применяю и проверяю через web:
![image](https://github.com/user-attachments/assets/c48ac2ac-2800-4960-9e17-74c417183944)

Теперь выполню деплой моего тестового приложения:
[nginx.yaml](https://github.com/oviplokos/netology-diplom/blob/main/monitoring/nginx.yaml)

Создаю необходимые манифесты и применяю:   

![image](https://github.com/user-attachments/assets/1ff5c73f-63bb-41e2-bdf2-ea880d2f05e2)


Тестовое приложение доступено на 80-м порту по адресу 
![image](https://github.com/user-attachments/assets/f2d19752-d9ae-416c-b915-3536869cb789)





---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.
## Решение   

Для ci/cd буду испльзовать web-версию GitHub Actions.
Создаю раннер в директории моего проекта:   
Устанавливаю и запускаю раннер на master-ноде кластера
![image](https://github.com/user-attachments/assets/4fe1a191-7e02-4a1f-aec4-c92fcd25089e)



Далее необходимо написать workflow:
```yaml
name: Build and Deploy to Kubernetes

on:
  push:
    branches:
      - main
    tags:
      - 'v*'
env:
  IMAGE_NAME: oviplokos/nginx-diplom
  NAMESPACE: nginx-diplom
  DEPLOYMENT_NAME: nginx-diplom

jobs:
  build:
    runs-on: self-hosted

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Determine Docker tag
        run: |
          if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
            echo "TAG=latest" >> $GITHUB_ENV
          elif [[ "${{ github.ref }}" == refs/tags/* ]]; then
            echo "TAG=${GITHUB_REF#refs/tags/}" >> $GITHUB_ENV
          fi
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}
          
      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: true 
          tags: |
            ${{ env.IMAGE_NAME }}:${{ env.TAG }}
                 
  deploy:
    needs: build
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: self-hosted
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: List files in the working directory
      run: |
        ls -la

    - name: Extract version from tag or commit message
      run: |
        echo "GITHUB_REF: ${GITHUB_REF}"
        if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
          VERSION=${GITHUB_REF#refs/tags/}
        else
          VERSION=$(git log -1 --pretty=format:%B | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' || echo "")
        fi
        if [[ -z "$VERSION" ]]; then
          echo "No version found in the commit message or tag"
          exit 1
        fi
        VERSION=${VERSION//[[:space:]]/}  # Remove any spaces
        echo "Using version: $VERSION"
        echo "VERSION=${VERSION}" >> $GITHUB_ENV

    - name: Replace image tag in nginx.yaml
      run: |
        if [ ! -f /home/netology/kube-manifest/nginx.yaml ]; then
          echo "nginx.yaml not found in the current directory"
          exit 1
        fi
        sed -i "s|image: oviplokos/nginx-diplom:.*|image: ${{ env.IMAGE_NAME }}:${{ env.VERSION }}|" /home/netology/kube-manifest/nginx.yaml 

    - name: Apply Kubernetes manifests
      run: |
        kubectl apply -f /home/netology/kube-manifest/nginx.yaml -n nginx-diplom
```
Добавляю необходимые секреты:
![image](https://github.com/user-attachments/assets/304e0bac-a418-470b-98f0-51eaacecbf53)

Проверяем условие "При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа"
![image](https://github.com/user-attachments/assets/35cfbc65-5fbc-4b92-9faf-97225739ed85)

![image](https://github.com/user-attachments/assets/87f0f53f-af23-4d26-97f8-31e0454ac67f)

Видим , чтоо actions отработал и при этом deploy в k8s не был запущен:

Проверяем условие "При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes"
![image](https://github.com/user-attachments/assets/ecc13ec1-f069-406f-ba2c-b976a9fff3cb)

Создался образ на DockerHub:
![image](https://github.com/user-attachments/assets/968b4d6e-3f25-4ffe-b19b-d745c1bac6f4)

Приложение обновилось:
![image](https://github.com/user-attachments/assets/6828e015-9a13-4941-aa26-da5ef848485f)


---
