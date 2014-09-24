ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel 'Invoices' do
          table do
            tr do
              td do
                strong Invoice.count
                span 'Total Invoices'
              end
              td do
                strong Invoice.outstanding.count
                span 'Outstanding Invoices'
              end
              td do
                strong Invoice.paid.count
                span 'Paid Invoices'
              end
            end
          end
        end

        panel "Campaigns" do
          table do
            tr do
              td do
                strong Campaign.count
                span 'Total Campaigns'
              end
              td do
                strong Campaign.active.count
                span 'Active Campaigns'
              end
              td do
                strong Campaign.past.count
                span 'Past Campaigns'
              end              
            end
            tr do
              td do
                strong Campaign.to_end.count
                span 'Campaigns about to end'
              end
              td do
                strong Campaign.unlaunched.count
                span 'Campaigns unlaunched'
              end
            end  
          end
        end

        panel "Pledges" do
          #h4 'Pledges Summary'
          table do
            tr do
              td do
                strong Pledge.count
                span 'Total Pledges'
              end
              td do
                strong Pledge.active.count
                span 'Active Pledges'
              end
              td do
                strong Pledge.past.count
                span 'Past Pledges'
              end              
            end
            tr do
              td do
                strong Pledge.pending.count
                span 'Pending Pledges'
              end 
              td do
                strong Pledge.rejected.count
                span 'Rejected Pledges'
              end   
              td do
                strong Pledge.fully_subscribed.count
                span 'Fully Subscribed Pledges'
              end
            end
          end
          # hr
          # h4 'Top 10 Pledges'
          # ul do
          #   Pledge.highest.limit(10).each do |pledge|
          #     li link_to pledge.name, admin_pledge_path(pledge)
          #   end
          # end

        end

      end

      column do
        panel 'Sponsors' do
          table do
            tr do
              td do
                h4 'Top 10'
                ol do
                  Sponsor.rank.limit(10).each do |sponsor|
                    li link_to sponsor.name, admin_sponsor_path(sponsor)
                  end
                end
              end

              td do
                h4 'Latest'
                ul do
                  Sponsor.latest.limit(5).each do |sponsor|
                    li link_to sponsor.name, admin_sponsor_path(sponsor)
                  end
                end  
              end
            end
          end
        end

        panel 'Fundraisers' do
          table do
            tr do
              td do
                h4 'Top 10'
                ol do
                  Fundraiser.rank.limit(10).each do |fundraiser|
                    li link_to fundraiser.name, admin_fundraiser_path(fundraiser)
                  end
                end
              end

              td do
                h4 'Latest'
                ul do
                  Fundraiser.latest.limit(5).each do |fundraiser|
                    li link_to fundraiser.name, admin_fundraiser_path(fundraiser)
                  end
                end
              end
            end
          end
        end

        # panel 'Invoices' do
        #   table do
        #     tr do
        #       td do
        #         strong Invoice.count
        #         span 'Total Invoices'
        #       end
        #       td do
        #         strong Invoice.outstanding.count
        #         span 'Outstanding Invoices'
        #       end
        #       td do
        #         strong Invoice.paid.count
        #         span 'Paid Invoices'
        #       end
        #     end
        #   end
        # end

      end

    end
  end # content

end
