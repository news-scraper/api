module ApplicationHelper
  def navigation_links
    @navigation_links ||= {
      "Domains"  => { link: domains_path, icon: "globe" },
      "Articles" => { link: news_articles_path, icon: "newspaper-o" },
      "Training" => { link: training_logs_path, icon: "plus" },
      "Queries"  => { link: scrape_queries_path, icon: "question" },
      "Sign Out" => { link: destroy_user_session_path, icon: "sign-out", method: 'delete' },
    }
  end
end
