class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.order(:codename).pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent
        .includes(:missions)
        .order(:codename)
        .map { |agent| "#{agent.codename}: #{agent.missions.map(&:title).sort.join(', ')}" }
        .join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent
        .left_joins(:missions)
        .includes(:missions)
        .group("agents.id")
        .order(Arel.sql("COUNT(missions.id) DESC"), :codename)
        .map { |agent| "#{agent.codename} (#{agent.missions.size}): #{agent.missions.map(&:title).sort.join(', ')}" }
        # .select
        .join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent
        .includes(:skills)
        .order(:codename)
        .map { |agent| "#{agent.codename}: #{agent.skills.map(&:name).sort.join(', ')}" }
        .join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      Skill
        .left_joins(:agents)
        .includes(:agents)
        .group("skills.id")
        .order(Arel.sql("COUNT(agents.id) DESC"), :name)
        .map { |skill| "#{skill.name} (#{skill.agents.size}): #{skill.agents.map(&:codename).sort.join(', ')}" }
        .join("\n")
    end
  end
end