-- ==
-- compiled input @ cluster-means.in
-- output @ cluster-means.out

include cluster_means_lib

default (f32)

fun main(cluster_sizes: [k]int) (points: [n][d]f32) (membership: [n]int): [k][d]f32 =
  streamRedPer (fn (acc: [k][d]f32) (elem: [k][d]f32) =>
                  map add_centroids acc elem)
               (fn (acc: *[k][d]f32) (inp: [chunksize]([d]f32,int)) =>
                  let (points', membership') = unzip inp
                  in cluster_sums_acc acc cluster_sizes points' membership')
               (replicate k (replicate d 0.0)) (zip points membership)
