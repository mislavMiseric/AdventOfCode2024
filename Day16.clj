(require '[clojure.java.io :as io])
(require '[clojure.string :as str])

(def current-min-result (atom 100000))
(def unique-tiles (atom []))

(def array-3d (atom nil))

(defn search-start [lines]
    (loop [row 0]
        (if (< row (count lines))
            (let [line (nth lines row)]
                (let [col (str/index-of line "S")]
                    (if col
                        [row col]
                        (recur (inc row))
                    )
                )
            )
        )
    )
)

(defn is-hash-at-position [lines rowindex colindex]
    (= \# (nth (nth lines rowindex) colindex))
)

(defn is-end-at-position [lines rowindex colindex]
    (= \E (nth (nth lines rowindex) colindex))
)

(defn was-there-with-same-orientation-and-lower-result [lines rowindex colindex orientation result]
    (> result (get-in @array-3d [rowindex colindex orientation]))
)

(defn next-indexes-for-orientation [lines rowindex colindex orientation]
    (case orientation
        0 [(dec rowindex) colindex]
        1 [rowindex (inc colindex)]
        2 [(inc rowindex) colindex]
        3 [rowindex (dec colindex)]
    )   
)

(defn set-new-result-in-3d [row col orientation new-value]
    (swap! array-3d assoc-in [(int row) (int col) (int orientation)] new-value)
)

(defn play-labirinth [lines rowindex colindex orientation result path]
    (if (< @current-min-result result)
        Integer/MAX_VALUE
        (if (is-end-at-position lines rowindex colindex)
            (do
                (cond (> @current-min-result result)
                    (do
                        (println "Current lowest score of path::" result)
                        (reset! current-min-result result)
                        (reset! unique-tiles (conj path [rowindex colindex])))

                (= @current-min-result result)
                    (do
                        (reset! unique-tiles
                            (vec (distinct (concat @unique-tiles (conj path [rowindex colindex]))))
                        )
                    )
                )
                result
            )
            (if (was-there-with-same-orientation-and-lower-result lines rowindex colindex orientation result)
                Integer/MAX_VALUE
                (if (is-hash-at-position lines rowindex colindex)
                    Integer/MAX_VALUE
                    (do
                        (set-new-result-in-3d rowindex colindex orientation result)
                        (min
                            (let [[row col] (next-indexes-for-orientation lines rowindex colindex orientation)]
                                (play-labirinth lines row col orientation (+ 1 result) (conj path [rowindex colindex]))
                            )
                            (let [[row col] (next-indexes-for-orientation lines rowindex colindex (mod (+ 4 (dec orientation)) 4))]
                                (play-labirinth lines row col (mod (+ 4 (dec orientation)) 4) (+ 1001 result) (conj path [rowindex colindex]))
                            )
                            (let [[row col] (next-indexes-for-orientation lines rowindex colindex (mod (inc orientation) 4))]
                                (play-labirinth lines row col (mod (inc orientation) 4) (+ 1001 result) (conj path [rowindex colindex]))
                            )
                        )
                    )
                )
            )
        )
    )
)

(defn create-3d-array [rows cols]
    (vec (
        for [r (range rows)]
            (vec 
                (for [c (range cols)]
                    (vec (repeat 4 Integer/MAX_VALUE))
                )
            )
        )
    )
)


(defn initialize-array-3d [rows cols]
    (reset! array-3d 
        (vec 
            (for [r (range rows)]
                (vec 
                    (for [c (range cols)]
                        (vec (repeat 4 Integer/MAX_VALUE))
                    )
                )
            )
        )
    )
)


(with-open [rdr (io/reader "resource/day16/input.txt")]
    (let [lines (vec (doall (line-seq rdr)))
        rows (count lines)
        cols (count (first lines))]
        (initialize-array-3d rows cols)
        (let [[row col] (search-start lines)]
            (println "Found 'S' at row:" row ", column:" col)
            (let [result (play-labirinth lines row col 1 0 [])]
                (println "Lowest score of path: " result)
                (println "Number of unique tiles for shortest paths: " (count (distinct @unique-tiles)))
            )
        )
    )
)