module Bamboo
  module Client

    #
    # Client for the Bamboo REST API
    #
    # http://confluence.atlassian.com/display/BAMBOO/Bamboo+REST+APIs
    #

    class Rest < Abstract

      attr_reader :cookies

      SERVICE = "/rest/api/latest"

      def initialize(http)
        super
        @cookies = nil
      end

      def login(username, password)
        url = File.join(SERVICE, 'plan')
        resp = @http.get_cookies(url, {
                                        :os_authType => 'basic',
                                        :os_username => username,
                                        :os_password => password
                                        }
                                  )
        @cookies = {:JSESSIONID => resp['JSESSIONID']}
      end

      def plans
        get("plan/").auto_expand Plan, @http
      end

      def projects
        get("project/").auto_expand Project, @http
      end

      def project_for(key)
        Project.new get("project/#{URI.escape key}").data, @http
      end

      def results
        get("result/").auto_expand Result, @http
      end

      def results_for(key)
        get("result/#{URI.escape key}").auto_expand Result, @http
      end

      def plan_for(key)
        Plan.new get("plan/#{URI.escape key}").data, @http
      end

      private

      def get(what, params = nil)
        @http.get File.join(SERVICE, what), params, @cookies
      end

      class Plan
        def initialize(data, http)
          @data = data
          @http = http
        end

        def enabled?
          @data['enabled']
        end

        def type
          @data['type'].downcase.to_sym
        end

        def name
          @data['name']
        end

        def key
          @data['key']
        end

        def url
          @data.fetch("link")['href']
        end

        def queue
          @http.post File.join(SERVICE, "queue/#{URI.escape key}"), {}, @http.cookies
        end

        def results
          doc = @http.get File.join(SERVICE, "result/#{URI.escape key}"), {}, @http.cookies
          doc.auto_expand Result, @http
        end
      end # Plan

      class Project
        def initialize(data, http)
          @data = data
          @http = http
        end

        def name
          @data['name']
        end

        def key
          @data['key']
        end

        def url
          @data.fetch("link")['href']
        end

        def plans
          @plans ||= (
            unless @data['plans'] && @data['plans']['plan']
              @data = @http.get(URI.parse(url), {:expand => 'plans'}, @http.cookies).data
            end

            @data.fetch('plans').fetch('plan').map { |e| Plan.new(e, @http) }
          )
        end
      end # Project

      class Result
        def initialize(data, http)
          @data = data
          @http = http

          @changes = nil
        end

        def state
          @data.fetch('state').downcase.to_sym
        end

        def life_cycle_state
          @data.fetch("lifeCycleState").downcase.to_sym
        end

        def successful?
          state == :successful
        end

        def reason
          details.fetch('buildReason')
        end

        def relative_time
          details.fetch('buildRelativeTime')
        end
        alias_method :relative_date, :relative_time

        def failed_test_count
          details.fetch('failedTestCount')
        end

        def successful_test_count
          details.fetch('successfulTestCount')
        end

        def start_time
          Time.parse details.fetch('buildStartedTime')
        end

        def completed_time
          Time.parse details.fetch('buildCompletedTime')
        end

        def number
          @data['number']
        end

        def key
          @data['key']
        end

        def plan_key
          key[/^(.+)-\d+$/, 1]
        end

        def id
          @data['id']
        end

        def url
          @data.fetch("link")['href']
        end

        def uri
          @uri ||= URI.parse(url)
        end

        def changes
          @changes ||= (
            doc = fetch_details("changes.change.files").doc_for('changes')
            doc.auto_expand Change, @http
          )
        end

        private

        def details
          @details ||= @http.get(uri).data
        end

        def fetch_details(expand)
          @http.get(uri, :expand => expand)
        end
      end # Result

      class Change
        def initialize(data, http)
          @data = data
          @http = http
        end

        def id
          @data['changesetId']
        end

        def date
          Time.parse @data['date']
        end

        def author
          @data['author']
        end

        def full_name
          @data['fullName']
        end

        def user_name
          @data['userName']
        end

        def comment
          @data['comment']
        end

        def files
          # could use expand here
          Array(@data.fetch('files')['file']).map do |data|
            {
              :name     => data['name'],
              :revision => data['revision']
            }
          end
        end


      end # Change

    end # Rest
  end # Client
end # Bamboo
