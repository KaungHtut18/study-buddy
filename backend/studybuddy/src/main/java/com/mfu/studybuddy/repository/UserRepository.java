package com.mfu.studybuddy.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.mfu.studybuddy.model.User;

@Repository
public interface UserRepository extends JpaRepository<User,Long>{
    public Optional<User> findByEmail(String email);

    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN TRUE ELSE FALSE END " +
       "FROM User u JOIN u.interestedUsers iu " +
       "WHERE u.id = :userId AND iu.id = :interestedUserId")
    boolean existsByInterestedUser(@Param("userId") Long userId, 
                                @Param("interestedUserId") Long interestedUserId);

    boolean existsByIdAndInterestedUsers_Id(Long userId, Long interestedUserId);

    // Use proper Spring Data JPA method names for pagination
    List<User> findAllByOrderByIdAsc(Pageable pageable);
    
    List<User> findByIdGreaterThanOrderByIdAsc(Long lastId, Pageable pageable);

    // New: exclude a specific user when paging forward
    List<User> findByIdGreaterThanAndIdNotOrderByIdAsc(Long lastId, Long id, Pageable pageable);
}
