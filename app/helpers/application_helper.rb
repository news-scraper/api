module ApplicationHelper
  def navigation_links
    @navigation_links ||= begin
      links = {
        "Domains"  => { link: domains_path, icon: "globe" },
        "Articles" => { link: news_articles_path, icon: "newspaper-o" },
        "Training" => { link: training_logs_path, icon: "plus" },
        "Queries"  => { link: scrape_queries_path, icon: "question" },
        "Profile"  => { link: profile_path, icon: 'user' },
        "Sign Out" => { link: destroy_user_session_path, icon: "sign-out", method: 'delete' },
      }
      links.map { |_, link_info| link_info[:active] = current_page?(link_info[:link]) ? 'active' : '' }
      links
    end
  end
end
