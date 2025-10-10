package com.mfu.studybuddy.configs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import com.mfu.studybuddy.security.UserIdFilter;

@EnableWebSecurity
@Configuration
public class SecurityConfig {
    
    @Autowired
    private UserIdFilter userIdFilter;

    @Bean
    public SecurityFilterChain apSecurityFilterChain(HttpSecurity http) throws Exception{
        http
            .securityMatcher("/api/**")
            .addFilterBefore(userIdFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            .csrf(csrf -> csrf.disable());

        return http.build();
    }
}
