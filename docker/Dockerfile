#**********************************************
FROM registry.cn-beijing.aliyuncs.com/shaoyang_builds/ruby:2.3.4
MAINTAINER ShaoYang
ADD . /usr/src/app
RUN bundle install --local
CMD bash -c "rake db:setup&&bundle exec unicorn -p3000 -E $RAILS_ENV"
